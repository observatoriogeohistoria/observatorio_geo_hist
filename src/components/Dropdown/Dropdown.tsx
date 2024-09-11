import { styled } from "@mui/system";
import { HashLink } from "react-router-hash-link";
import { NavItem } from "../Navbar/NavItems";

export interface DropdownProps {
  submenuItems: NavItem[];
}

const DropdownContainer = styled("div")(({ theme }) => ({
  position: "absolute",
  right: 0,
  left: "auto",

  display: "flex",
  flexDirection: "column",

  minWidth: "160px",
  marginBottom: "4px",
  zIndex: 9999,
  overflow: "hidden",

  borderRadius: "4px",
  boxShadow:
    "0 10px 15px -3px rgba(46, 41, 51, 0.08), 0 4px 6px -2px rgba(71, 63, 79, 0.16)",
}));

const SubmenuItem = styled(HashLink)(({ theme }) => ({
  backgroundColor: theme.palette.background.default,
  color: theme.palette.secondary.main,
  fontSize: (theme.typography as any).body1.fontSize,
  textAlign: "center",
  textWrap: "nowrap",
  textDecoration: "none",

  padding: "8px 16px",
  cursor: "pointer",

  "&:hover": {
    backgroundColor: theme.palette.secondary.main,
    color: theme.palette.secondary.contrastText,
  },
}));

const Dropdown = ({ submenuItems }: DropdownProps) => {
  return (
    <DropdownContainer>
      {submenuItems.map((item) => (
        <SubmenuItem to={item.path} key={item.id}>
          {item.title}
        </SubmenuItem>
      ))}
    </DropdownContainer>
  );
};

export default Dropdown;
