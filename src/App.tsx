import { Box, styled } from "@mui/material";
import Footer from "./components/Footer/Footer";
import Navbar from "./components/Navbar/Navbar";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import About from "./pages/About";
import History from "./pages/History";
import Geography from "./pages/Geograph";

const AppContainer = styled(Box)({
  display: "flex",
  flexDirection: "column",
  minHeight: "100vh",
});

const Content = styled(Box)({
  flex: "1",
  display: "flex",
  flexDirection: "column",
});

function App() {
  return (
    <Router>
      <AppContainer>
        <Navbar />
        <Content>
          <Routes>
            <Route path="/" element={<About />} />
            <Route path="/historia" element={<History />} />
            <Route path="/geografia" element={<Geography />} />
          </Routes>
        </Content>
        <Footer />
      </AppContainer>
    </Router>
  );
}

export default App;
