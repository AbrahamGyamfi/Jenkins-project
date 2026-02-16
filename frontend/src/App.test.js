import { render, screen } from '@testing-library/react';
import App from './App';

// Mock fetch globally
global.fetch = jest.fn();

describe('App Component', () => {
  beforeEach(() => {
    fetch.mockClear();
    fetch.mockResolvedValue({
      ok: true,
      json: async () => []
    });
  });

  test('renders TaskFlow heading', () => {
    render(<App />);
    const headingElement = screen.getByText(/taskflow/i);
    expect(headingElement).toBeInTheDocument();
  });

  test('renders task form', () => {
    render(<App />);
    const inputElement = screen.getByPlaceholderText(/task title/i);
    expect(inputElement).toBeInTheDocument();
  });

  test('fetches tasks on mount', () => {
    render(<App />);
    expect(fetch).toHaveBeenCalledWith(expect.stringContaining('/api/tasks'));
  });
});
