import React from 'react';
import { useLocation, Link } from 'react-router-dom';
import { Construction, ArrowLeft } from 'lucide-react';

interface ModulePlaceholderProps {
  title?: string;
  stepName?: string;
}

export const ModulePlaceholderPage: React.FC<ModulePlaceholderProps> = ({
  title,
  stepName,
}) => {
  const location = useLocation();
  const displayTitle = title || location.pathname.replace('/', '').replace(/-/g, ' ').toUpperCase();

  return (
    <div className="card p-12 text-center max-w-xl mx-auto my-12 border-dashed">
      <div className="w-16 h-16 bg-paper-alt rounded-full flex items-center justify-center mx-auto mb-4 border border-paper-border text-brand-navy">
        <Construction className="w-8 h-8" />
      </div>
      <h1 className="font-serif text-2xl font-bold text-brand-navy mb-2">
        {displayTitle}
      </h1>
      <p className="text-sm text-paper-muted max-w-md mx-auto mb-6">
        This financial submodule is part of the upcoming phased implementation roadmap ({stepName || 'Steps 16–21'}).
        The core domain models and backend APIs are fully tested and ready.
      </p>

      <div className="inline-flex gap-3">
        <Link to="/dashboard" className="btn btn-primary">
          <ArrowLeft className="w-4 h-4" />
          <span>Return to Dashboard</span>
        </Link>
      </div>
    </div>
  );
};

