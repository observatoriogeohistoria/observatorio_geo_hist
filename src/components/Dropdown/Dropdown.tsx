import { styled } from "@mui/system";
import { NavItem } from "../Navbar/NavItems";
import colors from "../../utils/colors";

export interface DropdownProps {
  submenuItems: NavItem[];
}

const DropdownContainer = styled("div")({
  position: "absolute",
  right: 0,
  left: "auto",
  fontSize: "0.5rem",
  zIndex: 9999,
  minWidth: "160px",
});

const SubmenuItem = styled("div")({
  backgroundColor: colors.tertiary,
  color: colors.secondary,
  fontSize: "1.5rem",
  padding: "8px 16px",
  textAlign: "center",
  cursor: "pointer",

  "&:hover": {
    backgroundColor: colors.secondary,
    color: colors.tertiary,
  },
});

const Dropdown = ({ submenuItems }: DropdownProps) => {
  return (
    <DropdownContainer>
      {submenuItems.map((item) => (
        <SubmenuItem key={item.id}>{item.title}</SubmenuItem>
      ))}
    </DropdownContainer>
  );
};

export default Dropdown;
