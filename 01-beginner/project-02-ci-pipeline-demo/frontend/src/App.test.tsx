import { render, screen } from '@testing-library/react';
import App from './App';

let fetchSpy: jest.SpyInstance;

beforeAll(() => {
  fetchSpy = jest.spyOn(global, 'fetch');
});

afterEach(() => {
  jest.clearAllMocks();
});

test('renders app without crashing', async () => {
  fetchSpy.mockResolvedValueOnce({
    json: async () => ({ message: 'Loading Test' }),
  });

  render(<App />);

  const appElement = await screen.findByRole('heading');
  expect(appElement).toBeInTheDocument();
});

test('displays hello world text', async () => {
  const expectedMessage = 'Hello World from Dockerized App!';

  fetchSpy.mockResolvedValueOnce({
    json: async () => ({ message: expectedMessage }),
  });

  render(<App />);

  const fullHeaderText = new RegExp(expectedMessage, 'i');

  const helloWorldElement = await screen.findByText(fullHeaderText);

  expect(helloWorldElement).toBeInTheDocument();

  expect(fetchSpy).toHaveBeenCalledTimes(1);
  expect(fetchSpy).toHaveBeenCalledWith('http://localhost:8000');
});