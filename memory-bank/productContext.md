# Product Context: Cubitos Dice Rolling Tray

## Game Background

Cubitos is a board game that uses dice as a core mechanic. Players roll dice to determine their actions and movement. The game features special dice where some faces have symbols and others are blank.

## Problem Statement

In the physical game, players need to:

1. Roll multiple dice at once
2. Separate dice that show symbols from those that show blank faces
3. Make decisions based on the results

This manual process can be tedious and error-prone in a digital implementation like Tabletop Simulator.

## Solution

Our dice rolling tray automates this process by:

1. Providing a single button to roll all dice at once
2. Automatically detecting which face is showing on each die
3. Sorting the dice into separate areas based on whether they show symbols or blank faces
4. Allowing players to quickly see their results and make decisions

## User Experience Goals

1. **Simplicity**: One-click operation to roll all dice
2. **Clarity**: Clear visual separation between symbol dice and blank dice
3. **Accuracy**: Reliable detection of dice faces
4. **Efficiency**: Quick resolution of dice rolls to maintain game flow
5. **Flexibility**: Works with different dice configurations (varying numbers of symbol faces)

## Integration with Game Flow

The dice rolling tray is designed to integrate seamlessly with the Cubitos game flow:

1. Player clicks the roll button during their turn
2. Dice are rolled and automatically sorted
3. Player can immediately see which dice showed symbols and which showed blanks
4. Player can make decisions based on the results without manual sorting

This automation enhances the digital implementation of Cubitos by removing tedious manual tasks and allowing players to focus on strategic decisions.
