import { Box, styled, ThemeProvider } from "@mui/material";
import { Route, BrowserRouter as Router, Routes } from "react-router-dom";
import Footer from "./components/Footer/Footer";
import Navbar from "./components/Navbar/Navbar";
import About from "./pages/About";
import Geography from "./pages/Geograph";
import History from "./pages/History";
import { theme } from "./utils/theme";

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
    <ThemeProvider theme={theme}>
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
    </ThemeProvider>
  );
}

export default App;
