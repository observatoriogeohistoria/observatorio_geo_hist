import { styled, Theme } from "@mui/system";
import { useState } from "react";
import Logo from "../../assets/logo.png";
import Dropdown from "../Dropdown/Dropdown";
import { navItems } from "./NavItems";

const Header = styled("header")(({ theme }: { theme: Theme }) => ({
  width: "100%",
  height: "144px",
  position: "sticky",
  top: 0,
  backgroundColor: theme.palette.background.default,
}));

const NavbarContainer = styled("div")({
  width: "90%",
  height: "100%",
  margin: "0 auto",
  display: "flex",
  justifyContent: "space-between",
  alignItems: "center",
});

const NavbarLogo = styled("img")(({ theme }) => ({
  width: "100%",
  maxWidth: "400px",
}));

const Menus = styled("ul")(({ theme }) => ({
  display: "flex",
  alignItems: "center",
  gap: theme.spacing(6),
}));

const MenuItem = styled("div")(({ theme }: { theme: Theme }) => ({
  position: "relative",
  borderRadius: "4px",
  color: theme.palette.secondary.main,

  "&:hover": {
    color: theme.palette.primary.contrastText,
    backgroundColor: theme.palette.primary.main,
    cursor: "pointer",
  },
}));

const MenuLink = styled("div")(({ theme }) => ({
  width: "100%",
  fontSize: (theme.typography as any).subtitle2.fontSize,
  padding: `${theme.spacing(2)} ${theme.spacing(3)}`,
  cursor: "pointer",
}));

const Navbar = () => {
  const [dropdown, setDropdown] = useState<number | null>(null);

  return (
    <>
      <Header>
        <NavbarContainer>
          <NavbarLogo src={Logo} alt="Logo" />
          <Menus>
            {navItems.map((item, index) => {
              return (
                <MenuItem
                  key={item.id}
                  onMouseEnter={() => setDropdown(item.id)}
                  onMouseLeave={() => setDropdown(null)}
                >
                  <MenuLink>{item.title}</MenuLink>
                  {dropdown === item.id && (
                    <Dropdown submenuItems={item.subMenu ?? []} />
                  )}
                </MenuItem>
              );
            })}
          </Menus>
        </NavbarContainer>
      </Header>
    </>
  );
};

export default Navbar;
