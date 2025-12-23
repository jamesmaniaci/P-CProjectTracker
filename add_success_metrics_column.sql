-- Add success_metrics column to existing projects table
-- Run this in Supabase SQL Editor if your table already exists

ALTER TABLE projects ADD COLUMN IF NOT EXISTS success_metrics TEXT DEFAULT '';

