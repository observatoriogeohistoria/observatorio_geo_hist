import { AppBar, Toolbar, Button, Box } from "@mui/material";
import { styled } from "@mui/system";
import InstagramIcon from "@mui/icons-material/Instagram";
import FacebookIcon from "@mui/icons-material/Facebook";
import WhatsAppIcon from "@mui/icons-material/WhatsApp";
import LogoImage from "../../assets/logo.png";
import colors from "../../utils/colors";
import { NavLink } from "react-router-dom";
import DropdownMenu from "../DropdownMenu/DropdownMenu";

const NavbarContainer = styled(AppBar)(({ theme }) => ({
  backgroundColor: colors.background,
}));

const Logo = styled("img")(({ theme }) => ({
  height: 96,
  marginRight: theme.spacing(2),
}));

const SocialButton = styled(Button)(({ theme }) => ({
  color: colors.secondary,
  fontSize: "40px",
  "&:hover": {
    backgroundColor: colors.secondaryLighter,
  },
}));

const NavLinkStyled = styled(NavLink)(({ theme }) => ({
  color: colors.secondary,
  textDecoration: "none",
  marginRight: theme.spacing(2),
  "&.active": {
    color: colors.primary,
    fontWeight: "bold",
  },
}));

const Navbar = () => {
  const historySubsections = [
    { path: "publicacoes", label: "Publicações" },
    { path: "biblioteca", label: "Biblioteca" },
  ];

  const geographySubsections = [
    { path: "pesquisas", label: "Pesquisas" },
    { path: "recursos", label: "Recursos" },
  ];

  return (
    <NavbarContainer position="static">
      <Toolbar>
        <Logo src={LogoImage} alt="Logo" />
        <Box display="flex" justifyContent="center" flexGrow={1}>
          <Box
            sx={{
              margin: "0 48px",
            }}
          >
            <NavLinkStyled to="/" end>
              {({ isActive }) => (
                <div className={isActive ? "active" : ""}>SOBRE</div>
              )}
            </NavLinkStyled>
          </Box>
          <DropdownMenu
            section="historia"
            label="HISTÓRIA"
            subsections={historySubsections}
          />
          <DropdownMenu
            section="geografia"
            label="GEOGRAFIA"
            subsections={geographySubsections}
          />
        </Box>
        <Box display="flex" justifyContent="flex-end">
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
