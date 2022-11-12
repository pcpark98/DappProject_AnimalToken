/// <reference types="react-scripts" />

// 윈도우라는 객체에 메타 마스크를 설치하면 이더리움이라는 오브젝트가 생김.
// 리액트에서는 이더리움 오브젝트를 인식하지 못함.
// 그래서 타입을 강제로 적어주는 것.

interface Window {
  ethereum: any;
}
