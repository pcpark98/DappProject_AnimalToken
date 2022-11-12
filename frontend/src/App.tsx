import React, { FC, useEffect, useState } from "react";
import { Button } from "@chakra-ui/react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Main from "./routes/main";

const App: FC = () => {
  const [account, setAccount] = useState<string>("");
  // 지금 접속되어 있는 메타 마스크 계정을 담을 변수.

  const getAccount = async () => {
    // 메타 마스크를 통해 계정을 가져오는 함수.

    try {
      if (window.ethereum) {
        // 메타 마스크가 설치되어 있으면 이게 실행될 것이고, 안되어 있으면 실행 안됨.
        const accounts = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        // 지금 접속되어 있는 메타 마스크 계정의 주소가 나옴.

        setAccount(accounts[0]);
      } else {
        // 이더리움이 없으면
        alert("Install Metamask!");
      }
    } catch (error) {
      console.log(error);
    }
  };
  useEffect(() => {
    getAccount();
  }, []);
  useEffect(() => {
    console.log(account);
  }, [account]);

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Main />} />
      </Routes>
    </BrowserRouter>
  );
};

export default App;
