import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import App from './App';

// Helper function to render App with Router
const renderWithRouter = (initialEntries = ['/']) => {
  return render(
    <MemoryRouter initialEntries={initialEntries}>
      <App />
    </MemoryRouter>
  );
};

test('renders insurance client portal header', () => {
  renderWithRouter();
  const headerElement = screen.getByText(/Insurance Client Portal/i);
  expect(headerElement).toBeInTheDocument();
});

test('renders dashboard by default', () => {
  renderWithRouter();
  const dashboardElement = screen.getByText(/Dashboard/i);
  expect(dashboardElement).toBeInTheDocument();
});

test('renders navigation buttons', () => {
  renderWithRouter();
  const dashboardButton = screen.getByRole('button', { name: /Dashboard/i });
  const claimsButton = screen.getByRole('button', { name: /Claims/i });
  const profileButton = screen.getByRole('button', { name: /Profile/i });
  
  expect(dashboardButton).toBeInTheDocument();
  expect(claimsButton).toBeInTheDocument();
  expect(profileButton).toBeInTheDocument();
});

test('renders claims statistics on dashboard', () => {
  renderWithRouter();
  const totalClaimsElement = screen.getByText(/Total Claims/i);
  const pendingClaimsElement = screen.getByText(/Pending Claims/i);
  
  expect(totalClaimsElement).toBeInTheDocument();
  expect(pendingClaimsElement).toBeInTheDocument();
}); 