import React from "react";
import { Box, Typography, Grid } from "@mui/material";
import { styled } from "@mui/system";
import ufuLogo from "../../assets/about/partners/ufu.png";
import fapemigLogo from "../../assets/about/partners/fapemig.png";
import cnpqLogo from "../../assets/about/partners/cnpq.png";
import capesLogo from "../../assets/about/partners/capes.png";
import facedLogo from "../../assets/about/partners/faced.png";
import ppgedLogo from "../../assets/about/partners/ppged.png";
import proppLogo from "../../assets/about/partners/propp.png";
import proexcLogo from "../../assets/about/partners/proexc.png";

const Section = styled(Box)(({ theme }) => ({
  padding: theme.spacing(4),
  textAlign: "center",
}));

const Image = styled("img")(({ theme }) => ({
  width: "100%",
  maxWidth: "200px",
  margin: theme.spacing(2, 0),
}));

const Partners: React.FC = () => {
  const partners = [
    { name: "UFU", logo: ufuLogo },
    { name: "FAPEMIG", logo: fapemigLogo },
    { name: "CNPq", logo: cnpqLogo },
    { name: "CAPES", logo: capesLogo },
    { name: "FACED", logo: facedLogo },
    { name: "PPGED", logo: ppgedLogo },
    { name: "ProPP", logo: proppLogo },
    { name: "PROEXC", logo: proexcLogo },
  ];

  return (
    <Section>
      <Typography variant="h3">PARCEIROS</Typography>
      <Grid container spacing={2} justifyContent="center">
        {partners.map((partner, index) => (
          <Grid item key={index} xs={12} sm={6} md={4}>
            <Image src={partner.logo} alt={partner.name} />
          </Grid>
        ))}
      </Grid>
    </Section>
  );
};

export default Partners;
