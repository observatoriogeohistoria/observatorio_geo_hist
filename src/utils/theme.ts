import { createTheme } from "@mui/material";

export const theme = createTheme({
  spacing: [0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 56, 64],

  palette: {
    primary: { main: "#ff9800", light: "#faa932", contrastText: "#ffffff" },
    secondary: { main: "#5c5a5a", light: "#b8b6b6", contrastText: "#ffffff" },
    background: {
      default: "#ffffff",
    },
  },

  typography: {
    fontFamily: "Helvetica Neue",

    fontWeightLight: 300,
    fontWeightRegular: 400,
    fontWeightMedium: 500,
    fontWeightBold: 700,

    h1: { fontSize: "3.5rem" },
    h2: { fontSize: "3rem", fontWeight: 700 },
    subtitle1: { fontSize: "2.5rem" },
    subtitle2: { fontSize: "2rem" },
    body1: { fontSize: "1.5rem" },
    body2: { fontSize: "1rem" },
  },
});
