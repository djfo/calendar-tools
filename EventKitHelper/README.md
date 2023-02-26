# EventKitHelper

The `EventKitHelper` program takes a start and an end date as input, queries calendar data within the given period of time (via the `EventKit` framework), and outputs events in JSON or TSV (tab-separated values) format.

## Build

Build the program using the Swift package manager

    % swift build

## Invocation

Output all events in 2022 as JSON (default)

    % swift run EventKitHelper \
        2022-01-01T00:00:00Z \
        2023-01-01T00:00:00Z

NOTE: One JSON object is printed per line.

Output event as TSV

    % swift run EventKitHelper \
        2022-01-01T00:00:00Z \
        2023-01-01T00:00:00Z \
        --tsv
