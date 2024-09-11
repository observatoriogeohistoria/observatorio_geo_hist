import { Box } from "@mui/material";
import React from "react";
import OurHistory from "../components/About/OurHistory";
import Partners from "../components/About/Partners";
import Team from "../components/About/Team";
import WhoWeAre from "../components/About/WhoWeAre";

const About: React.FC = () => {
  return (
    <Box>
      <WhoWeAre />
      <OurHistory />
      <Team />
      <Partners />
    </Box>
  );
};

export default About;
