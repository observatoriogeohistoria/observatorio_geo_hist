import React from "react";
import { Box } from "@mui/material";
import WhoWeAre from "../components/About/WhoWeAre";
import OurHistory from "../components/About/OurHistory";
import Team from "../components/About/Team";
import Partners from "../components/About/Partners";

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
