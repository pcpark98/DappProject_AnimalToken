import React, { FC, useEffect, useState } from "react";
import { Button } from "@chakra-ui/react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Main from "./routes/main";
import Layout from "./components/Layout";
import MyAnimal from "./routes/my-animal";
import SaleAnimal from "./routes/sale-animal";

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
      }
    } catch (error) {
      console.log(error);
    }
  };

  useEffect(() => {
    getAccount();
  }, []);

  return (
    <BrowserRouter>
      <Layout>
        <Routes>
          <Route path="/" element={<Main account={account} />} />
          <Route path="/my-animal" element={<MyAnimal account={account} />} />
          <Route
            path="/sale-animal"
            element={<SaleAnimal account={account} />}
          />
        </Routes>
      </Layout>
    </BrowserRouter>
  );
};

export default App;
