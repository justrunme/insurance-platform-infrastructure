import { render, screen } from '@testing-library/react';
import App from './App';

test('renders insurance client portal', () => {
  render(<App />);
  const linkElement = screen.getByText(/insurance/i);
  expect(linkElement).toBeInTheDocument();
});

test('renders claims section', () => {
  render(<App />);
  const claimsElement = screen.getByText(/claims/i);
  expect(claimsElement).toBeInTheDocument();
});

test('renders customers section', () => {
  render(<App />);
  const customersElement = screen.getByText(/customers/i);
  expect(customersElement).toBeInTheDocument();
}); 