import React, { useState } from "react";
import { styled } from "@mui/system";
import { navItems } from "./NavItems";
import Dropdown from "../Dropdown/Dropdown";
import colors from "../../utils/colors";
import Logo from "../../assets/logo.png";

const Header = styled("header")({
  width: "100%",
  height: "144px",
  backgroundColor: colors.background,
  position: "sticky",
  top: 0,
});

const NavbarContainer = styled("div")({
  width: "60%",
  height: "100%",
  margin: "0 auto",
  display: "flex",
  justifyContent: "space-between",
  alignItems: "center",
});

const NavbarLogo = styled("img")(({ theme }) => ({
  width: "100%",
  maxWidth: "400px",
  margin: theme.spacing(2, 0),
}));

const Menus = styled("ul")({
  display: "flex",
  alignItems: "center",
  listStyle: "none",
});

const MenuItem = styled("div")({
  position: "relative",
  borderRadius: "4px",

  "&:hover": {
    color: colors.tertiary,
    backgroundColor: colors.primary,
    cursor: "pointer",
  },
});

const MenuLink = styled("div")({
  width: "100%",
  fontSize: "2rem",
  padding: "8px 16px",
  cursor: "pointer",
});

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
