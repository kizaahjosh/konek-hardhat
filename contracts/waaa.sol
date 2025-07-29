// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoList {

    uint public taskCount = 0;

    // Define Task struct
    struct Task {
        uint id;
        string content;
        bool completed;
        address creator; // Track who created the task
    }

    // Mapping to store tasks
    mapping(uint => Task) public tasks;

    // Event definitions
    event TaskCreated(uint indexed id, string content, address indexed creator);
    event TaskCompleted(uint indexed id, bool completed);
    event TaskDeleted(uint indexed id, address indexed creator);

    // Create a new task
    function createTask(string memory _content) public {
        taskCount++;
        tasks[taskCount] = Task(taskCount, _content, false, msg.sender);  // Store the sender as the task creator
        emit TaskCreated(taskCount, _content, msg.sender);
    }

    // Complete a task (only the task creator can complete it)
    function completeTask(uint _id) public {
        Task storage task = tasks[_id];

        // Ensure that only the creator can mark the task as completed
        require(task.creator == msg.sender, "You are not the creator of this task!");

        task.completed = true;
        emit TaskCompleted(_id, true);
    }

    // Retrieve task details by ID
    function getTask(uint _id) public view returns (uint, string memory, bool, address) {
        Task memory task = tasks[_id];
        return (task.id, task.content, task.completed, task.creator);
    }

    // Optional: Allow task deletion (if needed)
    function deleteTask(uint _id) public {
        Task storage task = tasks[_id];

        // Ensure only the creator can delete the task
        require(task.creator == msg.sender, "You are not the creator of this task!");

        // Emit the event before making changes to the state (for safety)
        emit TaskDeleted(_id, task.creator);

        // Delete task from the mapping
        delete tasks[_id];
        
        // Reduce the task count
        taskCount--;

        // Ensure task count does not underflow
        if (taskCount < 0) {
            taskCount = 0;
        }
    }
}
