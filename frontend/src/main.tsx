import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
import { AuthProvider } from './auth/AuthContext';
import { useAuth } from './auth/AuthContext';
import { MatrizAdminPage } from './pages/MatrizAdminPage';
import './index.css';

function RouteEntry() {
  const { user } = useAuth();
  if (window.location.pathname === '/admin/matriz' && user?.rol === 'admin') return <MatrizAdminPage />;
  return <App />;
}

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <AuthProvider><RouteEntry /></AuthProvider>
  </StrictMode>
);
