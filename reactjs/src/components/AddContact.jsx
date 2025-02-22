import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { contactService } from '../services/api.ts';
import styled from 'styled-components';

const AddContact = () => {
  const [name, setName] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [email, setEmail] = useState('');
  const [homeAddress, setHomeAddress] = useState('');
  const [avatarUrl, setAvatarUrl] = useState('');
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await contactService.addContact({ name, phoneNumber, email, homeAddress, avatarUrl });
      navigate('/');
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <Container>
      <AppBar>
        <Title>Add Contact</Title>
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
        <Button type="submit">Add Contact</Button>
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

export default AddContact;