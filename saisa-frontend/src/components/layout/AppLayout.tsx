import React from 'react';
import { Outlet } from 'react-router-dom';
import { UtilityBar } from './UtilityBar';
import { MainNav } from './MainNav';
import { FunctionKeysBar } from './FunctionKeysBar';
import { Footer } from './Footer';

export const AppLayout: React.FC = () => {
  return (
    <div className="flex flex-col min-h-screen bg-paper text-paper-text">
      <UtilityBar />
      <MainNav />
      <FunctionKeysBar />
      <main className="flex-1 max-w-[1400px] w-full mx-auto p-4 md:p-6">
        <Outlet />
      </main>
      <Footer />
    </div>
  );
};
