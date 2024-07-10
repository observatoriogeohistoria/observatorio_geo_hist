// src/components/QuemSomos.tsx
import React from "react";
import { Box, Typography } from "@mui/material";
import { styled } from "@mui/system";
import WhoWeAreImage from "../../assets/about/whoe-we-are.png";
import colors from "../../utils/colors";

const SectionWithBackground = styled(Box)(({ theme }) => ({
  backgroundImage: `url(${WhoWeAreImage})`,
  backgroundSize: "cover",
  backgroundPosition: "center",
  color: colors.textSecondary,
  padding: theme.spacing(4),
  textAlign: "center",
  minHeight: "60vh",
  display: "flex",
  flexDirection: "column",
  justifyContent: "center",
  alignItems: "center",
}));

const Text = styled(Typography)(({ theme }) => ({
  margin: "32px auto",
  maxWidth: "800px",
}));

const WhoWeAre: React.FC = () => {
  return (
    <SectionWithBackground>
      <Typography variant="h3">QUEM SOMOS</Typography>
      <Text variant="body1">
        O Observatório de Ensino de História e Geografia é um espaço digital que
        possibilita o acesso, compartilhamento, a colaboração e a produção de
        conhecimentos. Nosso objetivo é oferecer um espaço/tempo que facilite o
        acesso a uma plataforma que congregue narrativas, dados, documentos,
        pesquisas, experiências didáticas e materiais diversos sobre o ensino e
        a aprendizagem de História e Geografia. O Observatório é destinado a
        professores, pesquisadores e estudantes que queiram conhecer e se
        aprofundar em discussões sobre práticas e saberes educativos. Nossa
        missão é promover a divulgação de conhecimentos relevantes e a
        circulação de saberes que contribuam para a formação permanente de
        professores e profissionais que atuam no campo do ensino de História,
        Geografia e áreas afins.
      </Text>
    </SectionWithBackground>
  );
};

export default WhoWeAre;
