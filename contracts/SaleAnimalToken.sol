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
}