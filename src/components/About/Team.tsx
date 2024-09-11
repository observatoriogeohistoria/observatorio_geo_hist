import { Box, Grid, Typography } from "@mui/material";
import { styled } from "@mui/system";
import React from "react";

const Section = styled(Box)(({ theme }) => ({
  padding: theme.spacing(4),
  textAlign: "center",
}));

const Team: React.FC = () => {
  const teamMembers = [
    { name: "John Doe", occupation: "Professor" },
    { name: "Jane Smith", occupation: "Researcher" },
  ];

  return (
    <Section id="Team">
      <Typography variant="h3">EQUIPE</Typography>
      <Grid container spacing={2} justifyContent="center">
        {teamMembers.map((member, index) => (
          <Grid item key={index} xs={12} sm={6} md={4}>
            <Typography variant="h6">{member.name}</Typography>
            <Typography variant="subtitle1">{member.occupation}</Typography>
          </Grid>
        ))}
      </Grid>
    </Section>
  );
};

export default Team;
