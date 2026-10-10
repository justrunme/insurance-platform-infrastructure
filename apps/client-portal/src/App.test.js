import { render, screen } from '@testing-library/react';
import App from './App';

test('renders insurance client portal header', () => {
  render(<App />);
  const headerElement = screen.getByText(/Insurance Client Portal/i);
  expect(headerElement).toBeInTheDocument();
});

test('renders dashboard by default', () => {
  render(<App />);
  const dashboardHeadings = screen.getAllByText(/Dashboard/i);
  expect(dashboardHeadings.length).toBeGreaterThan(0);
});

test('renders navigation links', () => {
  render(<App />);
  expect(screen.getByRole('link', { name: /Dashboard/i })).toBeInTheDocument();
  expect(screen.getByRole('link', { name: /^Claims$/i })).toBeInTheDocument();
  expect(screen.getByRole('link', { name: /Profile/i })).toBeInTheDocument();
});

test('renders claims statistics on dashboard', () => {
  render(<App />);
  expect(screen.getByText(/Total Claims/i)).toBeInTheDocument();
  expect(screen.getByText(/Pending Claims/i)).toBeInTheDocument();
});
