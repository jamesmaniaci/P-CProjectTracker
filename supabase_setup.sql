-- Supabase Database Setup for P&C Project Tracker
-- Run this in your Supabase SQL Editor

-- Create projects table
CREATE TABLE IF NOT EXISTS projects (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'Backlog',
  status_reason TEXT DEFAULT '',
  project_managers TEXT[] DEFAULT '{}',
  key_stakeholders TEXT[] DEFAULT '{}',
  success_metrics TEXT DEFAULT '',
  objective TEXT DEFAULT '',
  start_date DATE,
  target_finish DATE,
  submission_date DATE,
  manual_progress_override INTEGER,
  data JSONB NOT NULL DEFAULT '{}'::jsonb, -- Stores tasks, files, updates as JSON
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(status);
CREATE INDEX IF NOT EXISTS idx_projects_updated_at ON projects(updated_at);

-- Enable Row Level Security (RLS)
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- Create a policy that allows all authenticated users to read/write
-- For a team of 5, you can either:
-- Option 1: Allow all authenticated users (recommended for small team)
CREATE POLICY "Allow all operations for authenticated users" ON projects
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Option 2: If you want to restrict to specific users, use this instead:
-- CREATE POLICY "Allow team members" ON projects
--   FOR ALL
--   USING (auth.uid() IN (
--     SELECT id FROM auth.users WHERE email IN (
--       'user1@example.com',
--       'user2@example.com',
--       'user3@example.com',
--       'user4@example.com',
--       'user5@example.com'
--     )
--   ));

-- Create a function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to auto-update updated_at
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

