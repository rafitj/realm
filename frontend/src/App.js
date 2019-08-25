import React from 'react';
import { Typography } from 'antd';
import styled from 'styled-components';
import { observer } from 'mobx-react';
import { ImageUploader } from './@core/uploader/ImageUploader';
import { Sidebar } from './@core/sidebar/Sidebar';
import { SidebarState } from './@core/sidebar/SidebarState';
import { CreateProjectModal } from './@core/project-explorer/CreateProjectModal';

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

@observer
class App extends React.Component {
  state = new SidebarState();

  handleCreate = () => {
    const { form } = this.formRef.props;
    form.validateFields((err, values) => {
      if (err) {
        return;
      }
      form.resetFields();
      this.state.projectNames.push(values.title);
      this.state.closeModal();
    });
  };

  saveFormRef = formRef => {
    this.formRef = formRef;
  };

  render() {
    const { isOpen, closeModal, chosenProjectIndex, projectNames } = this.state;

    return (
      <Sidebar state={this.state}>
        <CreateProjectModal 
          wrappedComponentRef={this.saveFormRef}
          visible={isOpen}
          onCancel={closeModal}
          onCreate={this.handleCreate}
        />
        <Container>
          <TitleContainer level={2}>Realm</TitleContainer>
          <TitleContainer level={4}>Photos for Project {projectNames[chosenProjectIndex]}</TitleContainer>
          <ImageUploader/>
        </Container>
      </Sidebar>
    );
  }
}

export { App }; 