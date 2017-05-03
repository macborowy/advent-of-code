# Concurrent
This application is using GenServer, Supervisors, and Tasks to solve the exercise.

## Problems
This exercise was my first case ever, where I **have to use** GenServers (excluding samples from books). It is possible that this architecture/code is a bit odd or wrong, but it solves the problem, so it is a giant step forward.

I don't like how `lib/concurrent` directory looks - it feels a bit "mixed". It contains modules responsible for the application mechanic (Supervisor, Server, Worker) and "helper" modules. I don't imagine yet, how and where to place project files well.

Additionally, I don't know which parts of application require a significant testing. I also feel like I broke SRP and made Server has too much logic/responsibilities. This problem will be probably touched when I finish the second part of the exercise.

## Performance
Performance outstands my expectation. It is roughly 2000 times faster than brute force approach. It takes ~6 seconds to return a result (when I was testing the brute force approach it takes 6 seconds to process first command and each next command was longer).

The brute force approach was a dead end and I don't reccomend anyone trying to solve the exercise this way (I had no patience to wait for result and the lack of patience was a main reason to give GenServer a try).

## Extensibility
I'm writing this before starting the second part of the exercise to have a proof how I feel about introducing new requirement.

Even if I expect this code to break some rules and good pratices, I think implementing new logic will be easy-peasy. I'm gonna simply create a new worker implementation and use it instead of the previous one. 
