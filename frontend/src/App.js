import React from 'react';
import { Typography } from 'antd';
import styled from 'styled-components';
import { ImageUploader } from './@core/uploader/ImageUploader';
import { ProjectExplorer } from './@core/project-explorer/ProjectExplorer';

const { Title } = Typography;

const Container = styled.div`
  display: flex;
  width: 100%;
  justify-content: center;
  flex-direction: column;
  align-items: center;
`;

const TitleContainer = styled(Title)`
  diplay: block;
`;

function App() {
  return (
    <Container>
      <TitleContainer level={2}>Realm</TitleContainer>
      <ProjectExplorer />
      {/* <ImageUploader/> */}
    </Container>
  );
}

export default App;
