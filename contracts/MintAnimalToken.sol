// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MintAnimalToken is ERC721Enumerable {
    constructor() ERC721("h662Animals", "HAS") {}
    // 이 스마트 컨트랙트가 빌드될 때 한 번 실행됨.
    // 수행할 내용이 없으면 비워둬도 됨.
    // 생성자에 ERC721을 적어줘야 함. ERC721(name, symbol)의 형태
    // name과 symbol은 편한대로 적어도 됨.

    mapping(uint256 => uint256) public animalTypes;
    // 앞의 uint256은 animalTokenId, 뒤의 uint256은 animalType
    // 토큰 아이디를 입력하면 1 ~ 5번까지의 animalType이 랜덤하게 나옴.

    function mintAnimalToken() public {
        // 함수의 범위 public : 아무나 이 함수를 사용할 수 있게 함.
        
        uint256 animalTokenId = totalSupply() + 1;
        // animalTokenId : 새로 민팅될 NFT의 아이디.
        // totalSupply() : ERC721Enumerable에서 제공. 지금까지 민팅된 NFT의 양을 의미함.
        // + 1을 해줌으로써 새로 민팅될 NFT의 아이디 값을 구함.

        uint256 animalType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, animalTokenId))) % 5 + 1;
        // keccak 알고리즘을 통해 uint256 값을 구함.
        // abi.encodePacked(함수 실행 시간, 실행한 사람, 토큰 아이디)
        // % 5 + 1을 통해 1 ~ 5 사이의 값이 나옴.
        // solidity에서는 랜덤을 이렇게 뽑아냄.
        // 이 랜덤하게 나온 값을 위에서 정의한 매핑에 집어 넣자.

        animalTypes[animalTokenId] = animalType;
        // animalType으로 정의된 1 ~ 5번 중에 하나의 값이 민팅할 것에 들어감.


        _mint(msg.sender, animalTokenId);
        // ERC721에서 제공하는 민팅하는 함수.
        // msg.sender : 이 명령을 실행한 사람. 민팅 누른 사람.
        // animalTokenId : 발행될 NFT의 아이디.
    }
}