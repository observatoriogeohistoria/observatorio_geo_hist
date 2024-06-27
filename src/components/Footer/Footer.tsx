import React from "react";
import { Box, Typography, Divider } from "@mui/material";
import { styled } from "@mui/system";
import colors from "../../utils/colors";

const FooterContainer = styled(Box)(({ theme }) => ({
  backgroundColor: colors.primary,
  color: "#fff",
  padding: theme.spacing(2),
  textAlign: "center",
}));

const FooterText = styled(Typography)(({ theme }) => ({
  margin: theme.spacing(1, 0),
}));

const Footer: React.FC = () => {
  return (
    <FooterContainer>
      <FooterText variant="body1">
        Faculdade de Educação - Sala 1G156 - UFU - Av. João Naves de Ávila, 2121
        - B. Santa Mônica - Uberlândia/MG
        <br />
        34 3239-4163 | 34 3239-4212 | contato@observatoriogeohistoria.net.br
      </FooterText>
      <Divider style={{ backgroundColor: "#fff", margin: "20px 0" }} />
      <FooterText variant="body2">
        Observatório do Ensino de História e Geografia | 2024 | Conteúdo sob
        licença Creative Commons 4.0 Internacional
      </FooterText>
    </FooterContainer>
  );
};

export default Footer;
