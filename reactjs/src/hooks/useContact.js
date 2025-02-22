// src/hooks/useContact.js
import { useState, useEffect } from 'react';
import { contactService } from '../services/api.ts';

export const useContact = (id) => {
  const [contact, setContact] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchContact = async () => {
      try {
        const data = await contactService.getContactById(id);
        setContact(data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchContact();
  }, [id]);

  return { contact, loading, error };
};