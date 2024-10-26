# In Tank 3D Perception

This project involves designing and testing a simulation of the Movex M-27 mini dozer for hazardous environments, specifically focusing on nuclear waste tank cleaning. The simulation aims to analyze the traversability of the mini dozer, determining the conditions under which the robot might tip over as it moves within a nuclear waste tank. The analysis utilizes Jolt Physics and Godot for accurate simulations, and terrain data is randomly generated due to the unavailability of LiDAR data. The primary objective is to ensure safe and effective movement of the robot in hazardous environments by understanding its stability under different conditions.

# Project Overview
This simulation focuses on robotic movement within the unique and hazardous environment of nuclear tanks. We aim to evaluate different robot models for their ability to traverse the challenging terrain and obstructions found in these tanks. The current proof of concept utilizes the Movex M27 mini dozer, a compact and robust robotic platform.

## Key Objectives:
- Simulate realistic traversal scenarios based on known conditions of Hanford tanks.
- Perform traversability analysis of the robot in complex and constrained environments.

# Requirements
Before setting up the project, ensure you have the following installed:
- Godot Engine 4.0+ (required for running the simulation)
- <a href="https://godotengine.org/asset-library/asset/1918">Jolt Physics Library</a> (integrated into Godot for this project)

# Set up
To incorporate Jolt into Godot:
- Extract the Jolt files into your project directory
- Start or restart Godot
- Open project settings
- Enable Advanced Settings
- Go to "Physics" then to "3D"
- Change "Physics Engine" to "JoltPhysics3D"
- Restart Godot

## Resources
<a href="https://godotengine.org/download/macos/">Godot for Mac</a><br />
<a href="https://godotengine.org/download/windows/">Godot for Windows</a><br />
<a href="https://docs.godotengine.org/en/stable/getting_started/first_3d_game/index.html">Learn 3D Game Dev in Godot</a><br />
<a href="https://docs.godotengine.org/en/stable/tutorials/3d/introduction_to_3d.html#d-viewport">Working in 3D Space (Camera Movement)</a><br />
