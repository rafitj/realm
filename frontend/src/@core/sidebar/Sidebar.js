import React from 'react';
import { Layout, Menu, Icon } from 'antd';

import { observer } from 'mobx-react';

const { Content, Footer, Sider } = Layout;
const { SubMenu } = Menu;

@observer class Sidebar extends React.Component {
  onCollapse = collapsed => {
    const { state } = this.props;
    state.collapsed = collapsed;
  };

  render() {
    const { collapsed, openModal, projectNames } = this.props.state;

    return (
      <Layout style={{ minHeight: '100vh' }}>
        <Sider collapsible collapsed={collapsed} onCollapse={this.onCollapse}>
          <div className="logo" />
          <Menu theme="dark" defaultSelectedKeys={['-1']} mode="inline">
            <SubMenu
              key="sub1"
              title={
                <span>
                  <Icon type="book" />
                  <span>Projects</span>
                </span>
              }
            >
              {projectNames.map((name, i) => <Menu.Item key={i} onClick={() => this.props.state.chosenProjectIndex = i}>{name}</Menu.Item>)}
              <Menu.Item key={100} onClick={openModal}>New Project</Menu.Item>
            </SubMenu>
            <Menu.Item key="9">
              <Icon type="setting" />
              <span>Settings</span>
            </Menu.Item>
          </Menu>
        </Sider>
        <Layout>
          <Content>    
            <div style={{ padding: 24, background: '#fff', minHeight: 360 }}>
              {this.props.children}
            </div>
          </Content>
          <Footer style={{ textAlign: 'center' }}>Realm</Footer>
        </Layout>
      </Layout>
    );
  }
}

export { Sidebar };