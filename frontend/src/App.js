import React from 'react';
import { Typography } from 'antd';
import styled from 'styled-components';
import { ImageUploader } from './@core/uploader/ImageUploader';
import { ProjectExplorer } from './@core/project-explorer/ProjectExplorer';
import { Sidebar } from './@core/sidebar/Sidebar';
import { SidebarState } from './@core/sidebar/SidebarState';

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

export class App extends React.Component {
  state = new SidebarState();

  render() {
    return (
      <Sidebar state={this.state}>
        <Container>
          <TitleContainer level={2}>Realm</TitleContainer>
          <ProjectExplorer />
          {/* <ImageUploader/> */}
        </Container>
      </Sidebar>
    );
  }
}