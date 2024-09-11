import { Typography } from "@mui/material";
import { styled } from "@mui/system";
import React from "react";
import capesLogo from "../../assets/about/partners/capes.png";
import cnpqLogo from "../../assets/about/partners/cnpq.png";
import facedLogo from "../../assets/about/partners/faced.png";
import fapemigLogo from "../../assets/about/partners/fapemig.png";
import ppgedLogo from "../../assets/about/partners/ppged.png";
import proexcLogo from "../../assets/about/partners/proexc.png";
import proppLogo from "../../assets/about/partners/propp.png";
import ufuLogo from "../../assets/about/partners/ufu.png";

const Section = styled("div")(({ theme }) => ({
  textAlign: "center",
}));

const CardsContainer = styled("div")(({ theme }) => ({
  display: "flex",
  flexWrap: "wrap",
  justifyContent: "center",
  alignItems: "center",
  gap: theme.spacing(4),
  margin: `${theme.spacing(8)} auto`,
}));

const Card = styled("div")(({ theme }) => ({
  padding: theme.spacing(2),
  borderRadius: "4px",
  backgroundColor: theme.palette.background.default,
  boxShadow: "0 0 8px rgba(0, 0, 0, 0.1)",
}));

const Image = styled("img")(({ theme }) => ({
  width: "200px",
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
    <Section id="Partners">
      <Typography variant="h3">PARCEIROS</Typography>
      <CardsContainer>
        {partners.map((partner, index) => (
          <Card key={index}>
            <Image src={partner.logo} alt={partner.name} />
          </Card>
        ))}
      </CardsContainer>
    </Section>
  );
};

export default Partners;
