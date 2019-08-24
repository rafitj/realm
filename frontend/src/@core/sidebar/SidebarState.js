import { action, observable } from 'mobx';

export class SidebarState {
    @observable
    collapsed = true;

    @observable
    isOpen = false;
    
    @observable
    projectNames = ['Starter Test', 'Test 2', 'My Project'];

    @observable
    chosenProjectIndex = 0;

    @action
    openModal = () => {
        console.log('its open')
        this.isOpen = true;
    };

    @action
    closeModal = () => {
        this.isOpen = false;
    }

    @action
    addProject = (str) => {
        this.projectNames.push(str);
    };
}