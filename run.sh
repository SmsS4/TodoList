#!/bin/bash
cat core.swift commands.swift ui.swift main.swift > all.swift
swift all.swift
rm all.swift
