import React from 'react';
import { Table } from 'antd';
import styled from 'styled-components'; 

const columns = [
  { title: 'Name', dataIndex: 'name', key: 'name' },
  {
    title: 'Action',
    dataIndex: '',
    key: 'x',
    render: () => <React.Fragment><a>Delete</a>{' '}<a>Open</a></React.Fragment>,
  },
];

const TableContainer = styled(Table)`
  min-width: 80%;
`;

const data = [
  {
    key: 0,
    name: 'Rafit is nigga',
    description: '.',
  },
  {
    key: 1,
    name: 'AWS is sick',
    description: 'adi needs to sleep',
  },
];

export class ProjectExplorer extends React.Component {
    render() {
        return (
          <TableContainer
              columns={columns}
              expandedRowRender={record => <p style={{ margin: 0 }}>{record.description}</p>}
              dataSource={data}
          />
        );
    }
}