import React, { useState, useRef, FC } from "react";
import {
  Button,
  ClickAwayListener,
  Grow,
  Paper,
  Popper,
  MenuItem,
  MenuList,
} from "@mui/material";
import { styled } from "@mui/system";
import { NavLink } from "react-router-dom";

type DropdownMenuProps = {
  section: string;
  label: string;
  subsections: { path: string; label: string }[];
};

const MenuContainer = styled("div")(({ theme }) => ({
  margin: "0 48px",
}));

const DropdownMenu: FC<DropdownMenuProps> = ({
  section,
  label,
  subsections,
}) => {
  const [open, setOpen] = useState(false);
  const anchorRef = useRef<HTMLButtonElement>(null);

  const handleToggle = () => {
    setOpen((prevOpen) => !prevOpen);
  };

  const handleClose = (event: any) => {
    if (
      anchorRef.current &&
      anchorRef.current.contains(event.target as HTMLElement)
    ) {
      return;
    }
    setOpen(false);
  };

  return (
    <MenuContainer>
      <Button
        ref={anchorRef}
        aria-controls={open ? "menu-list-grow" : undefined}
        aria-haspopup="true"
        onClick={handleToggle}
      >
        {label}
      </Button>
      <Popper
        open={open}
        anchorEl={anchorRef.current}
        role={undefined}
        transition
        disablePortal
      >
        {({ TransitionProps, placement }) => (
          <Grow
            {...TransitionProps}
            style={{
              transformOrigin:
                placement === "bottom" ? "center top" : "center bottom",
            }}
          >
            <Paper>
              <ClickAwayListener onClickAway={handleClose}>
                <MenuList autoFocusItem={open}>
                  {subsections.map((subsection) => (
                    <MenuItem
                      key={subsection.path}
                      component={NavLink}
                      to={`/${section}/${subsection.path}`}
                      onClick={handleClose}
                    >
                      {subsection.label}
                    </MenuItem>
                  ))}
                </MenuList>
              </ClickAwayListener>
            </Paper>
          </Grow>
        )}
      </Popper>
    </MenuContainer>
  );
};

export default DropdownMenu;
