import React from "react";
import { Box, Typography, Grid } from "@mui/material";
import { styled } from "@mui/system";

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
    { name: "UFU", logo: "ufu.png" },
    { name: "FAPEMIG", logo: "fapemig.png" },
    { name: "CNPq", logo: "cnpq.png" },
    { name: "CAPES", logo: "capes.png" },
    { name: "FACED", logo: "faced.png" },
    { name: "PPGED", logo: "ppged.png" },
    { name: "ProPP", logo: "propp.png" },
    { name: "PROEXC", logo: "proexc.png" },
  ];

  return (
    <Section>
      <Typography variant="h3">PARCEIROS</Typography>
      <Grid container spacing={2} justifyContent="center">
        {partners.map((partner, index) => {
          const image = `../../assets/about/partners/capes.png`;

          return (
            <Grid item key={index} xs={12} sm={6} md={4}>
              <Image src={image} alt={partner.name} />
            </Grid>
          );
        })}
      </Grid>
    </Section>
  );
};

export default Partners;
