const express = require('express');
const { PrismaClient } = require('@prisma/client');
const bodyParser = require('body-parser');
const path = require('path');

const app = express();
const prisma = new PrismaClient();

app.use(bodyParser.json());
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

//  good think to have if you remmeber the link its better with /discord than discord link imo
app.get('/discord', async (req, res) => { 
    res.redirect("https://discord.gg/MVNZR73Ghf")
})

// do not tocuh like seriusly if you touch it it may break, it is hold up by a string and its trying its best to survive
app.get('/', async (req, res) => {
    const { view = 'users', page = 1, search = '' } = req.query; // this is for no reason, i could've done /users and /badservers but this is easier and a one page solution while still using one page

    const pageSize = 25; // you can change this, this just changes how much is shown, does not help the database requests :kekw: (i mean it does but count is allways got)
    
    try {
        /** 
         * @type {string}
        */
        let dataType;
        /**
         * @type {string}
         */
        let data;
        /**
         * @type {number}
         */
        let count;

        /**
         * @type {number}
         */
        const skip = (page - 1) * pageSize;
        if (isNaN(data)) {
            dataType == "name"
        } else {
            dataType == "id"
        }
        console.log(dataType);
        
        if (view === 'badservers') {
            if (dataType === "name") {
                count = await prisma.badServers.count({
                    where: {
                        name: {
                            contains: search,
                        }
                    }
                });
                data = await prisma.badServers.findMany({
                    where: {
                        name: {
                            contains: search,
                        }
                    },
                    include: {
                        Users: true
                    },
                    skip,
                    take: pageSize
                });
            } else {
                count = await prisma.badServers.count({
                    where: {
                        id: {
                            contains: search,
                        }
                    }
                });
                data = await prisma.badServers.findMany({
                    where: {
                        id: {
                            contains: search,
                        }
                    },
                    include: {
                        Users: true
                    },
                    skip,
                    take: pageSize
                });
            }
        } else {
            count = await prisma.users.count({
                where: {
                    id: {
                        contains: search,
                    }
                }
            });
            data = await prisma.users.findMany({
                where: {
                    id: {
                        contains: search,
                    }
                },
                skip,
                take: pageSize
            });
        }
        /**
         * @type {number}
         */
        const totalPages = count / pageSize;

        res.render('index', { view, data, page, totalPages, search });
    } catch (error) {
        console.error('Error fetching data:', error);
        res.status(500).send('Internal server error');
    }
});

// this is what allows u to do url/users with body of a userid and returns data.
app.get('/user', async (req, res) => {
    const { user_id } = req.query;

    if (!user_id) {
        return res.status(400).json({ success: false, message: 'Discord user ID is required' });
    }

    try {
        const user = await prisma.users.findUnique({
            where: {
                id: user_id,
            },
        });

        const userExists = !!user;
        if (userExists) {
            return res.json({ success: userExists, userid: user.id, last_username: user.last_username, status: user.status });
        } else {
            return res.json({ success: false, message: "This user is not in the database"})
        }
    } catch (error) {
        console.error('Error checking user:', error);
        return res.status(500).json({ success: false, message: 'Internal server error' });
    }
});
app.get('/server', async (req, res) => {
    const { server_id } = req.query;

    if (!server_id) {
        return res.status(400).json({ success: false, message: 'Discord Server ID is required' });
    }

    try {
        const server = await prisma.badServers.findUnique({
            where: {
                id: server_id,
            },
        });

        const serverExists = !!server;
        if (serverExists) {
            return res.json({ success: serverExists, id: server.id, name: server.name, reason: server.reason });
        } else {
            return res.json({ success: false, message: "This server is not in the database"})
        }
    } catch (error) {
        console.error('Error checking user:', error);
        return res.status(500).json({ success: false, message: 'Internal server error' });
    }
});
// this starts the server, if you dont do this, it will actually not work so start IT
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
