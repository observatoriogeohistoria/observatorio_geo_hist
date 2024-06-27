import React from "react";
import { AppBar, Toolbar, Button, Box } from "@mui/material";
import { styled } from "@mui/system";
import InstagramIcon from "@mui/icons-material/Instagram";
import FacebookIcon from "@mui/icons-material/Facebook";
import WhatsAppIcon from "@mui/icons-material/WhatsApp";
import LogoImage from "../../assets/logo.png";
import colors from "../../utils/colors";

const NavbarContainer = styled(AppBar)(({ theme }) => ({
  backgroundColor: colors.background,
}));

const Logo = styled("img")(({ theme }) => ({
  height: 96,
  marginRight: "auto",
}));

const SocialButton = styled(Button)(({ theme }) => ({
  color: colors.secondary,
  fontSize: "40px",
  "&:hover": {
    backgroundColor: colors.secondaryLighter,
  },
}));

const Navbar = () => {
  return (
    <NavbarContainer position="static">
      <Toolbar>
        <Logo src={LogoImage} alt="Logo" />
        <Box
          display="flex"
          flexDirection="row"
          justifyContent="space-between"
          alignItems="center"
        >
          <SocialButton
            aria-label="Instagram"
            href="https://www.instagram.com"
            rel="noopener noreferrer"
          >
            <InstagramIcon fontSize="inherit" />
          </SocialButton>
          <SocialButton
            aria-label="Facebook"
            href="https://www.facebook.com"
            rel="noopener noreferrer"
          >
            <FacebookIcon fontSize="inherit" />
          </SocialButton>
          <SocialButton
            aria-label="WhatsApp"
            href="https://wa.me/your-number"
            rel="noopener noreferrer"
          >
            <WhatsAppIcon fontSize="inherit" />
          </SocialButton>
        </Box>
      </Toolbar>
    </NavbarContainer>
  );
};

export default Navbar;
