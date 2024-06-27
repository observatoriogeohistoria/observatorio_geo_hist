import React from "react";
import { Box } from "@mui/material";
import WhoWeAre from "./WhoWeAre";
import OurHistory from "./OurHistory";
import Team from "./Team";
import Partners from "./Partners";

const AboutContent: React.FC = () => {
  return (
    <Box>
      <WhoWeAre />
      <OurHistory />
      <Team />
      <Partners />
    </Box>
  );
};

export default AboutContent;
