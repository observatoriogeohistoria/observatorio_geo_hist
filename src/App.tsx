import { Box, styled } from "@mui/material";
import Footer from "./components/Footer/Footer";
import Navbar from "./components/Navbar/Navbar";
import { BrowserRouter as Router } from "react-router-dom";
import AboutContent from "./components/About/About";

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
          <AboutContent />
        </Content>
        <Footer />
      </AppContainer>
    </Router>
  );
}

export default App;
