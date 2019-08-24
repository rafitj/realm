import React from 'react';
import { Table } from 'antd';

const columns = [
  { title: 'Name', dataIndex: 'name', key: 'name' },
  {
    title: 'Action',
    dataIndex: '',
    key: 'x',
    render: () => <React.Fragment><a>Delete</a>{' '}<a>Open</a></React.Fragment>,
  },
];

const data = [
  {
    key: 1,
    name: 'John Brown',
    description: 'My name is John Brown, I am 32 years old, living in New York No. 1 Lake Park.',
  },
  {
    key: 2,
    name: 'Jim Green',
    description: 'My name is Jim Green, I am 42 years old, living in London No. 1 Lake Park.',
  },
  {
    key: 3,
    name: 'Joe Black',
    description: 'My name is Joe Black, I am 32 years old, living in Sidney No. 1 Lake Park.',
  },
];

export class ProjectExplorer extends React.Component {
    render() {
        return (
        <Table
            columns={columns}
            expandedRowRender={record => <p style={{ margin: 0 }}>{record.description}</p>}
            dataSource={data}
        />
        );
    }
}