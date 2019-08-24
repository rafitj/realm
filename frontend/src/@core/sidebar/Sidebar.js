import React from 'react';
import { Layout, Menu, Breadcrumb, Icon } from 'antd';

const { Header, Content, Footer, Sider } = Layout;
const { SubMenu } = Menu;

export class Sidebar extends React.Component {

  onCollapse = collapsed => {
    const { state } = this.props;
    state.collapsed = collapsed;
  };

  render() {
    const { collapsed } = this.props.state;

    return (
      <Layout style={{ minHeight: '100vh' }}>
        <Sider collapsible collapsed={collapsed} onCollapse={this.onCollapse}>
          <div className="logo" />
          <Menu theme="dark" defaultSelectedKeys={['1']} mode="inline">
            <SubMenu
              key="sub1"
              title={
                <span>
                  <Icon type="book" />
                  <span>Projects</span>
                </span>
              }
            >
              <Menu.Item key="3">Temporary</Menu.Item>
              <Menu.Item key="4">Second thing</Menu.Item>
              <Menu.Item key="5">Thid thing</Menu.Item>
              <Menu.Item key="5">New Project</Menu.Item>
            </SubMenu>
            <Menu.Item key="9">
              <Icon type="setting" />
              <span>Settings</span>
            </Menu.Item>
          </Menu>
        </Sider>
        <Layout>
          <Content>    
            <div style={{ padding: 24, background: '#fff', minHeight: 360 }}>Bill is a cat.</div>
          </Content>
          <Footer style={{ textAlign: 'center' }}>Realm</Footer>
        </Layout>
      </Layout>
    );
  }
}