// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "MintAnimalToken.sol";

contract SaleAnimalToken {
    MintAnimalToken public mintAnimalTokenAddress;
    // MintAnimalToken을 deploy 하면 주소 값이 하나 나옴.
    // 그 값을 저장하기 위함.
    // 아래의 constructor를 이용해 저장.

    constructor (address _mintAnimalTokenAddress) {
        mintAnimalTokenAddress = MintAnimalToken(_mintAnimalTokenAddress);
    }

    mapping(uint256 => uint256) public animalTokenPrices;
    // 가격들을 관리하는 매핑.
    // 첫번째 uint256은 animalTokenId을, 두번째 uint256은 가격을 의미.
    // animalTokenId를 입력하면 출력은 가격이 나옴.
    // 3번째 require에서 사용됨.

    uint256[] public onSaleAnimalTokenArray;
    // 프론트엔드에서 어떤게 판매중인 토큰인지를 확인하기 위한 배열 

    function setForSaleAnimalToken(uint256 _animalTokenId, uint256 _price) public {
        // 판매 등록을 하기 위한 함수.
        // setForSaleAnimalToken(무엇을 팔지, 얼마에 팔지)

        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId);
        // 주인이 판매 등록을 해야 함. 다른 사람이 하면 안됨.
        // ownerOf() : 토큰 아이디 값을 넣어주면 주인이 누구인지 출력해주는 함수.


        // 주인이 맞는지 확인하기 위해 require를 사용할 것임.
        // require : 맞으면 다음 줄로 통과, 틀리면 에러를 출력.

        require(animalTokenOwner == msg.sender, "Caller is not animal token owner.");
        // 지금 이 함수를 실행하는 사람이 토큰의 주인이 맞는가?

        require(_price > 0, "Price is zero or lower.");
        // 0원보다 작으면 판매 등록을 할 수 없음.

        require(animalTokenPrices[_animalTokenId] == 0, "This animal token is already on sale.");
        // 두 가지 경우가 있음. 값이 있거나 0원이거나.
        // 0원이 아닌 경우는 이미 판매 등록이 된 것임.
        // 아직 판매하고 있지 않은 것은 0원인 상태.

        require(mintAnimalTokenAddress.isApprovedForAll(animalTokenOwner, address(this)), "Animal token owner did not approve token.");
        // isApprovedForAll(주인, 
        // 토큰의 주인이 판매 계약서(스마트 컨트랙트)에 판매 권한을 넘겼는지를 확인하는 함수. true false로 나옴.
        // 이 값이 true일 경우에만 통과되어서 판매할 수 있게 함.
        // 스마트 컨트랙트는 파일이라서 이상한 스마트 컨트랙트에 코인을 보내버리면 코인이 묶여서 영원히 찾을 수 없는 경우가 있음.

        // address(this) : 현재 파일(SaleAnimalToken)의 주소.


        animalTokenPrices[_animalTokenId] = _price;
        // 위에서 매핑했던대로 animalTokenId에다가 해당하는 가격을 넣어줌.

        onSaleAnimalTokenArray.push(_animalTokenId);
        // 판매중인 토큰 배열에 추가.
    }

    function purchaseAnimalToken(uint256 _animalTokenId) public payable{
        // 매틱이 왔다갔다 하는 함수들을 실행하기 위해 payable 키워드를 붙임.

        uint256 price = animalTokenPrices[_animalTokenId];
        // 매핑에 담겨있는 것을 꺼내오자.

        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId);
        // 주인의 주소값을 불러옴.

        require(price>0, "Animal token not sale.");
        // price가 0이하이면 판매 등록이 되어있지 않은 것.

        require(price <= msg.value, "Caller sent lower than price");
        // msg.value : 이 함수를 실행할 때 보내는 매틱의 양.
        // 보내는 매틱의 양이 가격보다 커야 함. 

        require(animalTokenOwner != msg.sender, "Caller is animal token owner.");
        // 함수를 호출한 사람이 주인이 아니어야만 구입이 가능하게 함.


        // 여기서부터 구매 로직
        payable(animalTokenOwner).transfer(msg.value);
        // 이 함수를 실행한 구매 희망자가 지불한 가격 만큼의 양이 토큰 주인에게 전송됨.

        mintAnimalTokenAddress.safeTransferFrom(animalTokenOwner, msg.sender, _animalTokenId);
        // nft 토큰이 돈을 지불한 사람에게 보내짐.
        // safeTransferFrom(보내는 사람, 받는 사람, 무엇을 보낼 것인가)

        // 이제 매핑의 값을 초기화하고, 판매중인 배열에서도 빼야함.
        
        animalTokenPrices[_animalTokenId] = 0;
        // 매핑에서 값을 초기화함.

        for(uint256 i = 0; i< onSaleAnimalTokenArray.length; i++){
            // 배열의 인덱스를 하나씩 보면서
            if(animalTokenPrices[onSaleAnimalTokenArray[i]]==0){
                // 방금 위에서 매핑을 0원으로 초기화 시킨 애를 찾아서 제거해줌.

                onSaleAnimalTokenArray[i] = onSaleAnimalTokenArray[onSaleAnimalTokenArray.length-1];
                // 현재 가격이 0원인 위치에 배열의 맨 뒤에 있는 애를 덮어씀

                onSaleAnimalTokenArray.pop();
                // 맨 뒤에 있는 것을 제거함.
            }
        }
    }

    function getOnSaleAnimalTokenArrayLength() view public returns(uint256){
        // 판매중인 토큰 배열의 길이를 리턴하는 함수.
        // returns()를 통해 반환 인자의 타입을 지정해줌.
        // 읽기전용이기 때문에 view라는 키워드를 붙임.

        return onSaleAnimalTokenArray.length;
        // 이 길이를 통해서 프론트에서 판매중인 리스트를 for문 돌려서 가져옴
    }

    function getAnimalTokenPrice(uint256 _animalTokenId) view public returns(uint256){
        return animalTokenPrices[_animalTokenId];
    }
}