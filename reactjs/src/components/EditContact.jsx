import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { contactService } from '../services/api.ts';
import styled from 'styled-components';

const EditContact = () => {
  const { id } = useParams();
  const [name, setName] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [email, setEmail] = useState('');
  const [homeAddress, setHomeAddress] = useState('');
  const [avatarUrl, setAvatarUrl] = useState('');
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchContact = async () => {
      try {
        const contact = await contactService.getContactById(id);
        setName(contact.name);
        setPhoneNumber(contact.phoneNumber);
        setEmail(contact.email);
        setHomeAddress(contact.homeAddress);
        setAvatarUrl(contact.avatarUrl);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchContact();
  }, [id]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await contactService.updateContact(id, { id, name, phoneNumber, email, homeAddress, avatarUrl });
      navigate('/');
    } catch (err) {
      setError(err.message);
    }
  };

  if (loading) return <Loading>Loading...</Loading>;
  if (error) return <Error>{error}</Error>;

  return (
    <Container>
      <AppBar>
        <Title>Edit Contact</Title>
      </AppBar>
      <Form onSubmit={handleSubmit}>
        {error && <Error>{error}</Error>}
        <Input
          type="text"
          placeholder="Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />
        <Input
          type="text"
          placeholder="Phone Number"
          value={phoneNumber}
          onChange={(e) => setPhoneNumber(e.target.value)}
          required
        />
        <Input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />
        <Input
          type="text"
          placeholder="Home Address"
          value={homeAddress}
          onChange={(e) => setHomeAddress(e.target.value)}
          required
        />
        <Input
          type="text"
          placeholder="Avatar URL"
          value={avatarUrl}
          onChange={(e) => setAvatarUrl(e.target.value)}
        />
        <Button type="submit">Done</Button>
      </Form>
    </Container>
  );
};

const Container = styled.div`
  background-color: #141414;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2rem;
`;

const AppBar = styled.div`
  background: #1a1a1a;
  padding: 1rem;
  color: white;
  width: 100%;
  text-align: center;
`;

const Title = styled.h1`
  margin: 0;
`;

const Form = styled.form`
  display: flex;
  flex-direction: column;
  width: 100%;
  max-width: 400px;
`;

const Input = styled.input`
  padding: 0.5rem;
  margin: 0.5rem 0;
  border: 1px solid #ccc;
  border-radius: 4px;
  background: #1a1a1a;
  color: white;
`;

const Button = styled.button`
  padding: 0.5rem;
  margin: 0.5rem 0;
  background: #1a1a1a;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
`;

const Error = styled.div`
  color: red;
  margin-bottom: 1rem;
`;

const Loading = styled.div`
  color: white;
  text-align: center;
  margin-top: 2rem;
`;

export default EditContact;