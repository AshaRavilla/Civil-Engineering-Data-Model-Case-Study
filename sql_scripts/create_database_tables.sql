-- ==================================================
-- SQL Script for Creating Tables for Civil Engineering Project Database
-- ==================================================

-- Clients Table: Stores basic information about clients
CREATE TABLE Clients (
    ClientID NUMBER PRIMARY KEY,
    ClientName VARCHAR(100),
    CompanyName VARCHAR(100)
);

-- Locations Table: Stores information about different locations
CREATE TABLE Locations (
    LocationID NUMBER PRIMARY KEY,
    LocationName VARCHAR(100),
    Development VARCHAR(100),
    Section NUMBER,
    Township VARCHAR(10),
    Range VARCHAR(10)
);

-- Tasks Table: Details about tasks that can be assigned
CREATE TABLE Tasks (
    TaskID NUMBER PRIMARY KEY,
    TaskDesc VARCHAR(100),
    Notes VARCHAR(100)
);

-- SurveyRequest Table: Stores information about survey requests
CREATE TABLE SurveyRequest (
    JobID NUMBER PRIMARY KEY,
    LocationID NUMBER,
    ClientID NUMBER,
    ContractDate DATE,
    Req_Date DATE,
    Comp_Date DATE,
    Drawing_sets CHAR(1),
    Restake NUMBER,
    CONSTRAINT fk_LocationID FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),
    CONSTRAINT fk_ClientID FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);

-- SurveyTask Table: Connects tasks with survey requests
CREATE TABLE SurveyTask (
    TaskID NUMBER,
    JobID NUMBER,
    CONSTRAINT pk_SurveyTask PRIMARY KEY (JobID, TaskID),
    CONSTRAINT fk_JobID FOREIGN KEY (JobID) REFERENCES SurveyRequest(JobID),
    CONSTRAINT fk_TaskID FOREIGN KEY (TaskID) REFERENCES Tasks(TaskID)
);

-- Employees Table: Stores employee details
CREATE TABLE Employees (
    EmpID NUMBER PRIMARY KEY,
    EmpName VARCHAR(50),
    JobTitle VARCHAR(50),
    ManagerName VARCHAR(50)
);

-- Crews Table: Stores details about work crews
CREATE TABLE Crews (
    CrewID NUMBER PRIMARY KEY,
    CrewDesc VARCHAR(50)
);

-- CrewAssignments Table: Assigns employees to crews
CREATE TABLE CrewAssignments (
    CrewID NUMBER,
    EmpID NUMBER,
    AsgnmtDet VARCHAR(100),
    CONSTRAINT pk_AssgnID PRIMARY KEY (CrewID, EmpID),
    CONSTRAINT fk_CrewID FOREIGN KEY (CrewID) REFERENCES Crews(CrewID),
    CONSTRAINT fk_EmpID FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

-- Schedule Table: Schedules tasks, assigning employees and crews to specific dates
CREATE TABLE Schedule (
    TaskID NUMBER,
    JobID NUMBER,
    WorkDate DATE,
    SchedulerID NUMBER,
    CrewID NUMBER,
    EmpID NUMBER,
    CONSTRAINT pk_scheduleID PRIMARY KEY (JobID, TaskID, WorkDate),
    CONSTRAINT fk_SurveyTaskDetails FOREIGN KEY (JobID,TaskID) REFERENCES SurveyTask(JobID,TaskID),
    CONSTRAINT fk_CrewAssgnment FOREIGN KEY (CrewID, EmpID) REFERENCES CrewAssignments(CrewID, EmpID),
    CONSTRAINT fk_schedID FOREIGN KEY (SchedulerID) REFERENCES Employees(EmpID)
);

-- SurveyBooks Table: Stores information about survey field books
CREATE TABLE SurveyBooks (
    FieldBookID NUMBER PRIMARY KEY,
    Location VARCHAR(100)
);

-- Fieldwork Table: Details specific fieldwork entries linked to tasks and surveys
CREATE TABLE Fieldwork (
    JobID NUMBER,
    TaskID NUMBER,
    WorkDate DATE,
    FieldworkID NUMBER,
    FieldworkStatus VARCHAR(50),
    FieldBookID NUMBER,
    FieldBookPg NUMBER,
    CONSTRAINT pk_Fieldwork PRIMARY KEY (JobID, TaskID, WorkDate, FieldworkID),
    CONSTRAINT fk_ScheduleDetails FOREIGN KEY (JobID, TaskID, WorkDate) REFERENCES Schedule(JobID, TaskID, WorkDate),
    CONSTRAINT fk_FieldBookID FOREIGN KEY (FieldBookID) REFERENCES SurveyBooks(FieldBookID)
);
