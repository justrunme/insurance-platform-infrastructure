import React from 'react';
import {
  Typography,
  Card,
  CardContent,
  Box,
  Grid,
  Avatar,
  List,
  ListItem,
  ListItemText,
  Divider,
  Button,
} from '@mui/material';

const Profile = () => {
  const userInfo = {
    name: 'John Doe',
    email: 'john.doe@email.com',
    phone: '+1 (555) 123-4567',
    address: '123 Main Street, Anytown, ST 12345',
    memberSince: '2020-03-15',
    customerID: 'CUST-2020-789'
  };

  const policies = [
    {
      type: 'Auto Insurance',
      policyNumber: 'POL-AUTO-2023-456',
      premium: '$1,200/year',
      status: 'Active',
      renewalDate: '2024-12-31'
    },
    {
      type: 'Home Insurance',
      policyNumber: 'POL-HOME-2023-789',
      premium: '$800/year',
      status: 'Active',
      renewalDate: '2024-11-15'
    },
    {
      type: 'Health Insurance',
      policyNumber: 'POL-HEALTH-2023-123',
      premium: '$3,600/year',
      status: 'Active',
      renewalDate: '2024-06-30'
    }
  ];

  const getInitials = (name) => {
    return name.split(' ').map(n => n[0]).join('').toUpperCase();
  };

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        My Profile
      </Typography>

      <Grid container spacing={3}>
        {/* Personal Information */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Box display="flex" alignItems="center" sx={{ mb: 3 }}>
                <Avatar 
                  sx={{ 
                    width: 80, 
                    height: 80, 
                    mr: 2,
                    bgcolor: 'primary.main',
                    fontSize: '2rem'
                  }}
                >
                  {getInitials(userInfo.name)}
                </Avatar>
                <Box>
                  <Typography variant="h5">
                    {userInfo.name}
                  </Typography>
                  <Typography color="textSecondary">
                    Customer ID: {userInfo.customerID}
                  </Typography>
                  <Typography variant="body2" color="textSecondary">
                    Member since {userInfo.memberSince}
                  </Typography>
                </Box>
              </Box>

              <List>
                <ListItem sx={{ px: 0 }}>
                  <ListItemText
                    primary="Email"
                    secondary={userInfo.email}
                  />
                </ListItem>
                <Divider />
                <ListItem sx={{ px: 0 }}>
                  <ListItemText
                    primary="Phone"
                    secondary={userInfo.phone}
                  />
                </ListItem>
                <Divider />
                <ListItem sx={{ px: 0 }}>
                  <ListItemText
                    primary="Address"
                    secondary={userInfo.address}
                  />
                </ListItem>
              </List>

              <Box sx={{ mt: 2 }}>
                <Button variant="outlined" size="small">
                  Edit Profile
                </Button>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        {/* Active Policies */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Active Policies
              </Typography>

              {policies.map((policy, index) => (
                <Box key={index}>
                  <Card variant="outlined" sx={{ mb: 2 }}>
                    <CardContent>
                      <Box display="flex" justifyContent="space-between" alignItems="flex-start">
                        <Box>
                          <Typography variant="subtitle1" gutterBottom>
                            {policy.type}
                          </Typography>
                          <Typography variant="body2" color="textSecondary">
                            Policy: {policy.policyNumber}
                          </Typography>
                          <Typography variant="body2" color="textSecondary">
                            Renewal: {policy.renewalDate}
                          </Typography>
                        </Box>
                        <Box textAlign="right">
                          <Typography variant="h6" color="primary">
                            {policy.premium}
                          </Typography>
                          <Typography variant="caption" color="success.main">
                            {policy.status}
                          </Typography>
                        </Box>
                      </Box>
                    </CardContent>
                  </Card>
                </Box>
              ))}

              <Box sx={{ mt: 2 }}>
                <Button variant="outlined" size="small">
                  View All Policies
                </Button>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        {/* Quick Actions */}
        <Grid item xs={12}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Quick Actions
              </Typography>
              <Grid container spacing={2}>
                <Grid item xs={12} sm={6} md={3}>
                  <Button variant="outlined" fullWidth>
                    File New Claim
                  </Button>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <Button variant="outlined" fullWidth>
                    Pay Premium
                  </Button>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <Button variant="outlined" fullWidth>
                    Download Documents
                  </Button>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                  <Button variant="outlined" fullWidth>
                    Contact Support
                  </Button>
                </Grid>
              </Grid>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Profile; 